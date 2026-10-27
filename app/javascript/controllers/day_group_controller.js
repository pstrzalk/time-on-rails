import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "icon", "entries"]
  static values = { date: String }

  connect() {
    this.render(this.storedCollapsed())
  }

  toggle() {
    const collapsed = !this.entriesTarget.classList.contains("hidden")
    this.store(collapsed)
    this.render(collapsed)
  }

  render(collapsed) {
    this.entriesTarget.classList.toggle("hidden", collapsed)
    this.iconTarget.classList.toggle("-rotate-90", collapsed)
    this.toggleTarget.setAttribute("aria-expanded", String(!collapsed))
  }

  get storageKey() {
    return `works:day-collapsed:${this.dateValue}`
  }

  storedCollapsed() {
    try {
      return localStorage.getItem(this.storageKey) === "1"
    } catch {
      return false
    }
  }

  store(collapsed) {
    try {
      if (collapsed) {
        localStorage.setItem(this.storageKey, "1")
      } else {
        localStorage.removeItem(this.storageKey)
      }
    } catch {
      // Storage unavailable (e.g. private mode): the toggle still works for this page view
    }
  }
}
