variable "credentials" {
    description = "My Credentials"
    default = ("./keys/my-creds.json")
}


variable "project" {
    description = "Project"
    default = "dtc-de-course-447302"
}

variable "location" {
    description = "Project Location"
    default = "US"

}

variable "region" {
    description = "Region"
    default = "us-east1"

}

variable "bq_dataset_name" {
    description = "My BigQuery Bucket Name"
    default = "demo_dataset"

}

variable "gcs_storage_class" {
    description = "My Storage Bucket Name"
    default = "dtc-de-course-447302-terra-bucket"

}