# Expense-EKS-terraform
* Install tools from bastion.sh 
```
wget -O bastion.sh https://raw.githubusercontent.com/Egopi1998/Expense-EKS-terraform/main/bastion.sh

```
* create password authentication between jenkins and Bastion
```
ssh-keygen -t rsa -b 4096
ssh-copy-id -i ~/.ssh/id_rsa.pub ec2-user@jenkins.hellandhaven.xyz
```
* run command to configure the eks
```
aws eks update-kubeconfig  --region us-east-1 --name expense-dev
```
* access the DB and configure as it is one time task 
```
mysql -h db-dev.hellandhaven.xyz -u root -pExpenseApp1
```
```
USE transactions;
```
```
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount INT,
    description VARCHAR(255)
);
```
```
CREATE USER IF NOT EXISTS 'expense'@'%' IDENTIFIED BY 'ExpenseApp@1';
```
```
GRANT ALL ON transactions.* TO 'expense'@'%';
```
```
FLUSH PRIVILEGES;
```
* EKS Ingress controller Setup
```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster expense-dev \
    --approve
```
```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/iam_policy.json
```
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```
```
eksctl create iamserviceaccount \
--cluster=expense-dev \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::522814732305:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve
```
* Add the eks-charts Helm chart repository.
```
helm repo add eks https://aws.github.io/eks-charts
```
* Update your local repo to make sure that you have the most recent charts.
```
helm repo update eks
```
* install controller
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=expense-dev \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```
* To check ingress controller pods running or not
```
kubectl get pods -n kube-system
or 
kubectl get deployment -n kube-system aws-load-balancer-controller
```
*  to uninstall
```
helm uninstall aws-load-balancer-controller -n kube-system
```

