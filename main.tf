terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# KMS Key
resource "aws_kms_key" "main" {
  description             = "KMS key for production baseline"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

# S3 Landing Zone Bucket with Encryption and Public Access Block
resource "aws_s3_bucket" "landing_zone" {
  bucket = "production-landing-zone-bucket"

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "landing_zone" {
  bucket = aws_s3_bucket.landing_zone.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.main.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "landing_zone" {
  bucket = aws_s3_bucket.landing_zone.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SQS Queue with DLQ
resource "aws_sqs_queue" "dlq" {
  name                      = "production-main-queue-dlq"
  message_retention_seconds = 1209600
  kms_master_key_id         = aws_kms_key.main.arn

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

resource "aws_sqs_queue" "main" {
  name              = "production-main-queue"
  kms_master_key_id = aws_kms_key.main.arn

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

# DynamoDB Metadata Table with PITR and SSE
resource "aws_dynamodb_table" "metadata" {
  name         = "production-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.main.arn
  }

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

# CloudWatch EventBridge Rule for FinOps Daily Sweep
resource "aws_cloudwatch_event_rule" "finops_daily_sweep" {
  name                = "finops-daily-sweep"
  description         = "Triggers daily FinOps sweep for cost optimization"
  schedule_expression = "cron(0 1 * * ? *)"

  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}
