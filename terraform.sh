R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
ACTION=$1
apply_cmd=$(find . -maxdepth 1 -type d ! -name ".")
destroy_cmd=$(find . -maxdepth 1 -type d ! -name "." | sort -r)
terraform_apply() {
    for i in $apply_cmd ; do
        cd "$i" || continue
        if [ -d .terraform ]; then
            echo -e "on $G $i $N .terraform repo exist...$G Creating the resource $N"
            terraform apply -auto-approve
            cd ..
            continue
        else
            echo -e "on $R $i $N .terraform repo not exist...$Y Skipping the $i $N"
            cd ..
            continue
        fi
    done
}
terraform_destroy() {
    for i in $destroy_cmd ; do
        cd "$i" || continue
        if [ -d .terraform ]; then
            echo -e "on $G $i $N .terraform repo exist...$G Destroying the resource $N"
            terraform destroy -auto-approve
            cd ..
            continue
        else
            echo -e "on $R $i $N .terraform repo not exist...$Y Skipping the $i $N"
            cd ..
            continue
        fi
    done
}
if [ "$ACTION" == "APPLY" ]; then
    terraform_apply
elif [ "$ACTION" == "DESTROY" ]; then
    terraform_destroy
else
    echo -e "Please provide the correct action $R APPLY $N or $R DESTROY $N"
fi