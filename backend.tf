terraform{
    backend "s3" {
    region = "ap-south-1"
    key = "terraform.tfstate"
    bucket = "main-state-file-bucket-for-shell-project-pjwesley7"
    }
}


