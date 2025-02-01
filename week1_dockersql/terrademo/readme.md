terraform: infrastrucutre as code that helps set up infrastrucuture in cloud or onsite.
use cases like servers, databases and networks
    Automation: It automates creating, updating, and deleting resources, saving time and reducing errors.
    Reproducibility: Ensures your infrastructure setup is predictable and repeatable.
    Collaboration: Infrastructure definitions can be shared and version-controlled, making it easier for teams to collaborate.
    Flexibility: It works with many cloud providers (e.g., AWS, Azure, GCP) and even on-premises setups.

providers enable terraform to communicate with other cloud platforms and services. bridge gap between terraform and other apis
key terraform commands

terraform init - get me providers that I need to complete task; initialize directory and setup backend
terraform plan - what am I about to do; apply configurations to current state to preview changes
terraform apply - do what is specified in terraform files; execution of changes
terraform destroy - remove everything defined in the terraform files