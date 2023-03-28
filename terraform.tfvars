versioning     = "Enabled" 

acl            = "private" 

bucket_name    = "webextestreceipts" 

bucket2_name   = "webextestarchive-storage" 

bucket3_name   = "webextestarchive-deletion" 

encryption     = "AES256" 

ami            = "ami-0f55a9d782a7612d8" 

instance_id    = "t2.micro" 

ec2_name       = "anc-01" 

ec2_2_name     = "anc-03" 

vpc_id         = "vpc-0c3bcaba944224c3f" 

subnet         = "subnet-014914742a0c3ecfa" 

subnet2        = "subnet-0ec01da7f9022e059" 

subnet3        = "subnet-00d8c6763f4d53c5f" 

ecs_name       = "infrastaging-ecs" 

container      = "enabled" 

service_name   = "infrastaging-service" 

family_ecs     = "tomcat-webserver" 

launchtemplate = "infrastaging" 

asg            = "infrastaging-asg" 

eccp           = "infrastaging-eccp" 

user           = "wbxadmin" 

pwd            = "wbxadmin" 

storage        = 20 

storage_type   = "gp2" 

instance_class = "db.t3.xlarge" 

engine         = "sqlserver-se" 

#zones          = ["eu-west-2a", "eu-west-2b"] 

db             = "infrastaging-mssql" 

dbversion      = "15.00.4153.1.v1" 
