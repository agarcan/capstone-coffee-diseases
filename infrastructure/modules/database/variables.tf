
variable "submissions_db" {
  description = "Table containing user, date of submission and submission id"
  type = string
  default = "submissions-db"
}


variable "location_db" {
  description = "Table containing submission location"
  type = string
  default = "location-db"
}


variable "weather_db" {
  description = "Table containing weather statistics preceding the submission"
  type = string
  default = "weather_db"
}


variable "detection_db" {
  description = "Table containing the detection labels of each submission"
  type = string
  default = "detection_db"
}