output "next_step" {
  value       = <<EOF



                Great job, you were able to deploy everything. Please follow below instructions
                1. https://console.cloud.google.com/
                2. Search for Uptime Check 
                3. Snapshot
                4. Send to slack



  EOF
  sensitive   = false
  description = "description"
  depends_on  = []
}
