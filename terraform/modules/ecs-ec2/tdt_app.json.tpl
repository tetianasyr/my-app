 [
    {
        "name": "${app_name}",
        "image": "${app_image}",
        "cpu": ${cpu},
        "portMappings": [
            {
                "containerPort": ${app_port},
                "hostPort": ${app_port},
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "ulimits": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${app_name}-${env}",
                "awslogs-create-group": "true",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        },
        "systemControls": []
    }
 ]