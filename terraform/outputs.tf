output "query_exec_time_report" {
  description = "The excution time on AWS RDS and local Docker"
  value = <<EOF
Execution time in AWS RDS result is located at:
"${local.codebase_root_path}/data/rds-exec-time.txt"
Execution time in Local (Docker) result is located at:
"${local.codebase_root_path}/data/docker-exec-time.txt"
EOF
    depends_on = [ 
        null_resource.run_ansible_playbook
     ]
}
