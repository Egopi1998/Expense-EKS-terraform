# Expense-EKS-terraform
* Install tools from bastion.sh 
```
curl -o 
```
* run command to configure the eks
```
Aws eks update-kubeconfig  --region us-east-a --name expense-dev
```
* access the DB and configure as it is one time task 
```
mysql -h db-dev.daws78s.online -u root -pExpenseApp1
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