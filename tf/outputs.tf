output "bucket_arn" { 

  value = aws_s3_bucket.bucket.arn 

} 

output "bucket2_arn" { 

  value = aws_s3_bucket.bucket2.arn 

} 

output "bucket3_arn" { 

  value = aws_s3_bucket.bucket3.arn 

} 

output "ec2_arn" { 

  value = aws_instance.ec2.arn 

} 

output "ec2_2_arn" { 

  value = aws_instance.ec2_2.arn 

} 

output "aws_ecs_cluster_cluster_name" { 

  description = "The name of the cluster" 

  value       = aws_ecs_cluster.ecs.name 

} 

output "aws_ecs_cluster_cluster_id" { 

  description = "The Amazon ID that identifies the cluster" 

  value       = aws_ecs_cluster.ecs.id 

} 

output "aws_ecs_cluster_cluster_arn" { 

  description = "The Amazon Resource Name (ARN) that identifies the cluster" 

  value       = aws_ecs_cluster.ecs.arn 

} 

 
