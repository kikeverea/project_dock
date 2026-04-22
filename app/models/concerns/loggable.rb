module Loggable
  extend ActiveSupport::Concern

  included do
    has_many :history_logs, as: :loggable, dependent: :nullify
  end

  class_methods do
    def display_model_name
      name, _name_attr, _gender = display_name
      name
    end

    def name_attr
      _name, name_attr, _gender = display_name
      name_attr
    end

    def gender
      _name, _name_attr, gender = display_name
      gender
    end

    def display_name
      case self.model_name.human
        when "Lead"
          %w[ Lead full_name m ]
        when "Activity"
          %w[ Viaje name m ]
        when "Correspondent"
          %w[ Corresponsal name m ]
        when "Company"
          %w[ Empresa name f ]
        when "Task"
          %w[ Tarea title f ]
        when "Document"
          %w[ Documento name m ]
        else
          raise "Invalid loggable model: #{model_name}"
      end
    end
  end

  def log!(user:, action:, name:nil, description:nil, tag: nil)
    if action == :updated
      previous_changes.except(:updated_at).each do |_field, (old, new)|
        HistoryLog.create(
          loggable: self,
          user: user,
          action: action,
          description: description || format_description(action, old, new),
          tag: tag
        )
      end
    elsif action == :uploaded || action == :upload_destroyed
      log_action = action == :uploaded ? :uploaded : :deleted
      HistoryLog.create(
        loggable: self,
        user: user,
        action: log_action,
        description: description || format_upload_description(name, log_action),
        tag: tag
      )
    else
      action = :deleted if action == :archived
      HistoryLog.create(
        loggable: self,
        user: user,
        action: action,
        description: description || format_description(action),
        tag: tag
      )
    end
  end

  def format_description(action, old=nil, new=nil)
    model_name, name_attr, gender = self.class.display_name
    name = self.send(name_attr)
    action_name = HistoryLog.action_es(action, gender)

    if old || new
      "En #{model_name} '#{name}', '#{old}' ha sido cambiado a '#{new}'"
    else
      "#{model_name} '#{name}' #{action_name}"
    end
  end

  def format_upload_description(name, action)
    model_name, name_attr, _gender = self.class.display_name
    name = name.length > 35 ? "#{name[0..35]}..." : name

    target_name = self.send(name_attr)
    action == :uploaded ?
      "#{name} subido a #{model_name} '#{target_name}'" :
      "#{name} de #{model_name} '#{target_name}' eliminado"
  end
end