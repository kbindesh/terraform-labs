data "template_file" "linux-vm-cloud-init" {
  template = file("azure-vm-minikube.sh")
}