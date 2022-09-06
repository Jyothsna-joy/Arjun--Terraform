variable connection_name {
  type        = string
  default     = "amktest"
  description = ""
}

variable provider_type {
  type        = string
  default     = "GITHUB"
  description = "description"
}

variable Name {
  type        = string
  default     = "amktest-apprunner-connection"
  description = "description"
}

variable service_name {
  type        = string
  default     = "amktest"
  description = "description"
}

variable build_command {
  type        = string
  default     = "pip install Flask"
  description = "description"
}

variable port {
  type        = string
  default     = "8080"
  description = "description"
}

variable runtime {
  type        = string
  default     = "PYTHON_3"
  description = "description"
}

variable start_command {
  type        = string
  default     = "python myapp.py"
  description = "description"
}

variable configuration_source {
  type        = string
  default     = "API"
  description = "description"
}

variable type {
  type        = string
  default     = "BRANCH"
  description = "description"
}

variable value {
  type        = string
  default     = "main"
  description = "description"
}







