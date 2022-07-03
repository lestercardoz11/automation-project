apt update -y

myname='lester'
s3_bucket='upgrad-lester'
timestamp=$(date '+%d%m%Y-%H%M%S')

if [ $(dpkg --list | grep apache2 | cut -d ' ' -f 3 | head -1) == 'apache2' ]
then
        echo "Apache2 is installed."
        if [[ $(systemctl status apache2 | grep disabled | cut -d ';' -f 2) == ' disabled' ]];
                then
                        systemctl enable apache2
                        echo "Apache2 enabled"
                        systemctl start apache2
                else
                        if [ $(systemctl status apache2 | grep active | cut -d ':' -f 2 | cut -d ' ' -f 2) == 'active' ]
                        then
                                echo "Apache2 is already running"
                        else
                                systemctl start apache2
                                echo "Apache2 started"
                        fi
        fi
else
        printf 'Y\n' | apt-get install apache2
        echo "Apache2 service installed"
fi



tar -zvcf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log


# Uploading to S3 bucket

if [ $(dpkg --list | grep awscli | cut -d ' ' -f 3 | head -1) == 'awscli' ]
        then
                aws s3 \
                cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
                s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

        else
        printf 'Y\n' | apt install awscli
        aws s3 \
        cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
        s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

fi


