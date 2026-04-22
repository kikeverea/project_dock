import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  connect() {
    console.log("TomSelect controller connected")

    const data = this.element.dataset

    this.placeholder = data.selectPlaceholder
    this.createUrl = data.createUrl
    this.createParamName = data.createParamName || "name"
    this.tagCreation = data.tagCreation ? data.tagCreation === "true" : true
    this.queryArgs = data.queryArgs ? JSON.parse(data.queryArgs) : {}
    this.createMessage = data.createMessage
    this.modelName = data.modelName
    this.buildUrl = data.buildUrl
    this.buildMethod = data.buildMethod?.toUpperCase() || "PATCH"
    this.containerSelector = data.containerCssSelector
    this.hideSearch = data.hideSearch === "true"
    this.isMultiple = this.element.hasAttribute("multiple")
    this.filterable = data.filterable || data.filter
    this.ignoreCharacterInSearch = data.ignoreCharacterInSearch
    this.localCreation = data.localCreation === "true"
    this.sameIdAndValue = data.sameIdAndValue === "true"

    if (this.isTomSelect(this.element)) return

    this.select = new TomSelect(this.element, this.config())

    const rawValue = this.element.dataset.value
    const isPlainText = rawValue != null && !/^\s*[\[{]/.test(rawValue.trim())

    const value = isPlainText
      ? rawValue
      : rawValue && JSON.parse(rawValue)

    if (value?.length || (value && !Array.isArray(value))) {
      this.setValue(value)
    }

    this.preventEscKeyEventPropagation()
  }

  disconnect() {
    if (this.select) {
      this.select.destroy()
      this.select = null
    }
  }

  // API
  listenToChangeEvents(listener) {
    this.selectionChangeListener = listener
  }

  // API
  disable(disabled, message = "") {
    this.element.disabled = disabled

    if (this.select) {
      if (disabled) {
        this.select.disable()
      } else {
        this.select.enable()
      }

      this.changePlaceholder(message || this.placeholder)
    } else {
      this.disabledPlaceholder = disabled ? message : ""
    }
  }

  // API
  listenToTagCreationRequests(listener) {
    this.tagCreationRequestsListener = listener
  }

  // API
  addAndSelectItem(id, name, data) {
    if (id && name) this.onItemCreated({ id, [this.createParamName]: name, data })
  }

  // API
  setFilter(filter) {
    this.filter = filter
    if (this.select) this.select.refreshOptions(false)
  }

  // API
  clearSelection() {
    if (this.select) {
      this.select.clear(true)
      this.dispatchNativeChange()
    }
  }

  // API
  addTagRequestArgs(args) {
    if (!this.tagRequestArgs) {
      this.tagRequestArgs = args
    } else {
      this.tagRequestArgs = { ...this.tagRequestArgs, ...args }
    }
  }

  changePlaceholder(placeholder) {
    if (!this.select) return

    this.select.settings.placeholder = placeholder || ""
    this.select.inputState()
  }

  config() {
    const config = {
      plugins: this.isMultiple ? ["remove_button"] : [],
      maxOptions: null,
      hideSelected: false,
      closeAfterSelect: !this.isMultiple,
      placeholder: this.disabledPlaceholder || this.placeholder || "",
      dropdownParent: this.containerSelector || null,
      create: false,
      allowEmptyOption: true,
      refreshThrottle: this.element.options.length > 100 ? 300 : 0,

      onChange: (value) => {
        this.dispatchNativeChange()

        if (this.selectionChangeListener) {
          this.selectionChangeListener({
            selectedOn: this.element.id,
            value
          })
        }
      },

      onDropdownOpen: () => {
        const input = this.select?.control_input
        if (input) input.setAttribute("autocomplete", "off")
      },

      score: (search) => {
        const baseScore = this.getSearchScorer(search)

        return (item) => {
          if (item?.hide === "true") return 0

          if (this.filterable && this.filter && item.text && !item.text.startsWith(this.createMessage || "Create ")) {
            if (item.filter !== this.filter) return 0
          }

          return baseScore(item)
        }
      },

      render: {
        option_create: (data, escape) => {
          return `<div class="create">${escape(data.input)}</div>`
        }
      }
    }

    if (this.hideSearch) this.addHideSearch(config)
    if (this.isMultiple) this.addMultiple(config)
    if (this.canCreateTags()) this.addTags(config)

    return config
  }

  isTomSelect(select) {
    return !!select.tomselect
  }

  canCreateTags() {
    return this.createUrl || this.buildUrl
  }

  addTags(config) {
    config.persist = false

    config.create = (input) => {
      this.searchValue = input

      const text = this.createMessage || `Create '${input}'`

      return {
        value: input,
        text,
        createMessage: true
      }
    }

    config.onItemAdd = async (value) => {
      const option = this.select.options[value]
      if (!option?.createMessage) return

      if (this.localCreation) {
        this.onItemCreated({ [this.createParamName]: this.searchValue })
      } else {
        await this.createSelectedValue(this.searchValue)
      }
    }
  }

  addMultiple(config) {
    config.plugins = [...(config.plugins || []), "remove_button"]
    config.closeAfterSelect = false
  }

  addHideSearch(config) {
    config.controlInput = null
  }

  getSearchScorer(search) {
    const query = (search || "").trim().toLowerCase()

    if (!query) {
      return () => 1
    }

    return (item) => {
      const text = (item.text || "").trim().toLowerCase()

      if (!text) return 0

      if (this.ignoreCharacterInSearch) {
        const normalizedQuery = query.replaceAll(this.ignoreCharacterInSearch, "")
        const normalizedText = text.replaceAll(this.ignoreCharacterInSearch, "")

        const searchWords = normalizedQuery.split(/\s+/)
        const itemWords = normalizedText.split(/\s+/)

        const isMatch = searchWords.every((searchWord) =>
          itemWords.some((itemWord) => itemWord.startsWith(searchWord))
        )

        return isMatch ? 1 : 0
      }

      return text.includes(query) ? 1 : 0
    }
  }

  setValue(value) {
    if (!this.select) return

    if (this.isMultiple) {
      const values = Array.isArray(value)
        ? value.map((element) => typeof element === "object" ? String(element.id) : String(element))
        : [String(value)]

      this.select.setValue(values, true)
    } else {
      const selectedValue = Array.isArray(value) ? value[0] : value
      this.select.setValue(String(selectedValue), true)
    }

    this.dispatchNativeChange()
  }

  async createSelectedValue(value) {
    const item = {}
    item[this.createParamName] = value

    if (this.tagRequestArgs) this.addArgsToItem(item, this.tagRequestArgs)

    await this.createItemForSelect(item)
  }

  getModelNameFromUrl() {
    const url = this.createUrl || this.buildUrl
    const match = url.match(/\W?(\w+)\W*/)
    const name = match?.[1]

    if (!name) return null

    return name.endsWith("s")
      ? name.substring(0, name.length - 1)
      : name
  }

  addArgsToItem(item, args) {
    for (const [key, value] of Object.entries(args)) {
      item[key] = value
    }
  }

  async createItemForSelect(item) {
    if (this.isMultiple) {
      this.removeCreateItemMessage()
    }

    const itemName = this.modelName || this.getModelNameFromUrl()
    const createUrl = this.createUrl
    const buildUrl = this.buildUrl && this.appendArgsToUrl(this.buildUrl, item)
    const buildMethod = this.buildMethod

    if (createUrl) {
      const created = await this.requestJSON(this.parseUrl(createUrl), {
        method: "POST",
        body: JSON.stringify({ [itemName]: item }),
        headers: {
          Accept: "application/json"
        }
      })

      this.tagCreationRequestsListener && this.tagCreationRequestsListener()
      this.onItemCreated(created)

      if (buildUrl) {
        const res = await this.requestText(this.parseUrl(`${buildUrl}/${created.id}`), {
          method: buildMethod,
          body: JSON.stringify(created),
          headers: {
            Accept: "text/vnd.turbo-stream.html; text/html; application/xhtml+xml"
          }
        })

        Turbo.renderStreamMessage(res)
      }
    } else if (buildUrl) {
      const res = await this.requestText(this.parseUrl(buildUrl), {
        method: buildMethod,
        body: buildMethod !== "GET" ? JSON.stringify({ [itemName]: item }) : undefined,
        headers: {
          Accept: "text/vnd.turbo-stream.html; text/html; application/xhtml+xml"
        }
      })

      this.tagCreationRequestsListener && this.tagCreationRequestsListener()
      Turbo.renderStreamMessage(res)
    }
  }

  parseUrl(path) {
    const queryArgs = Object.entries(this.queryArgs).reduce(
      (params, [key, value]) => {
        params.append(key, value)
        return params
      },
      new URLSearchParams({ tag_creation: String(this.tagCreation) })
    )

    return `${path}?${queryArgs.toString()}`
  }

  appendArgsToUrl(url, item) {
    const params = new URLSearchParams(item)
    return `${url}?${params.toString()}`
  }

  removeCreateItemMessage() {
    if (!this.select || !this.isMultiple) return

    const values = this.select.getValue()
    const selectedValues = Array.isArray(values) ? values : [values]

    const filtered = selectedValues.filter((value) => {
      const option = this.select.options[value]
      return !option?.createMessage
    })

    this.select.setValue(filtered, true)
    this.select.refreshItems()
    this.select.focus()
  }

  onItemCreated(created) {
    const { option, id } = this.createOptionElement(created)

    this.select.addOption(option)

    if (!this.isMultiple) {
      this.removeSelected()
    }

    this.selectOption(id)
  }

  createOptionElement(createdItem) {
    const param = createdItem[this.createParamName]
    const id = this.sameIdAndValue ? param : createdItem.id

    const option = {
      value: String(id),
      text: param,
      id: String(id),
      [this.createParamName]: param
    }

    if (createdItem.data) {
      Object.keys(createdItem.data).forEach((dataAttr) => {
        option[dataAttr] = createdItem.data[dataAttr]
      })
    }

    return { option, id: String(id) }
  }

  removeSelected() {
    const selected = this.select.getValue()

    if (Array.isArray(selected)) {
      selected.forEach((value) => this.select.removeOption(value))
    } else if (selected) {
      this.select.removeOption(selected)
    }
  }

  selectOption(id) {
    const value = String(id)

    if (this.isMultiple) {
      const current = this.select.getValue()
      const currentValues = Array.isArray(current) ? current : (current ? [current] : [])
      this.select.setValue([value, ...currentValues], true)
    } else {
      this.select.setValue(value, true)
    }

    this.dispatchNativeChange()
  }

  dispatchNativeChange() {
    this.element.dispatchEvent(new Event("change", { bubbles: true }))
  }

  preventEscKeyEventPropagation() {
    const input = this.select?.control_input
    if (!input) return

    input.addEventListener("keydown", (event) => {
      if (event.key === "Escape") event.stopPropagation()
    })
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }

  async requestJSON(url, options = {}) {
    const response = await fetch(url, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken(),
        ...(options.headers || {})
      }
    })

    if (!response.ok) {
      throw new Error(`Request failed: ${response.status}`)
    }

    return await response.json()
  }

  async requestText(url, options = {}) {
    const response = await fetch(url, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken(),
        ...(options.headers || {})
      }
    })

    if (!response.ok) {
      throw new Error(`Request failed: ${response.status}`)
    }

    return await response.text()
  }
}