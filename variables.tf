variable "apps" {
  type = map(object({
    image = string
    env = list(object({
      name : string,
      value : string
    }))
  }))
}
