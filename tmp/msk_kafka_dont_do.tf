data "aws_security_group" "main_service_bus_sg" {
  name = "kafka-sg-${var.environment}"
}

########################
# KMS Ecryption key
#####################

resource "aws_kms_key" "main_service_bus_key" {
  description = "aws kms key"
}

###################
# MSK Kafka 
###################
resource "aws_msk_cluster" "main_service_bus" {
  cluster_name           = "${var.environment}-cluster"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 3

  #Kafka broker
  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 30
    client_subnets = [
      aws_subnet.us-east-1a-database.id,
      aws_subnet.us-east-1b-database.id,
      aws_subnet.us-east-1c-database.id,
    ]
    security_groups = [data.aws_security_group.aws_security_group.id]
  }

  #Encryption
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms-kafka.arn
  }

  #Tagging
  tags = {
    Project = "${var.project}"
  }
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.main_service_bus.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.main_service_bus.bootstrap_brokers_tls
}