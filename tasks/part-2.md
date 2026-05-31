# Part 0: Scan environment

create a new branch using 

change some rights to owner

git checkout -b testbranch

git commit 
git push

check checkov and trivy
fix issues

in iac-scan.yml remove
    if: false # Remove this to enable Policy as Code (PaC) with Open Policy Agent

task:
add checkov policy to identify Owner
