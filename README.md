# split_tf_demo
Simple Terraform Demo with Split


You will need an admin API key and an environment named `Prod-Default` within a workspace that the API Key has access to with the name `Default`. 

This swill create a split, split definition, a segment, and a segment definition. The split uses the segment that we create in its targeting rules. 


Simply use `terraform init`, `terrraform plan` `terraform apply` and then destroy with `terraform destroy`
