@echo OFF

SET CONTAINER_NAME=msg_store-data_api
SET IMAGE="cam/message_store_data_api"

FOR /F "tokens=* USEBACKQ" %%g IN (`docker container ls -a --format "{{.Names}}"`) do (
    echo %%g=%CONTAINER_NAME%
    IF %%g==%CONTAINER_NAME% (
        echo Stopping and Removing container [%CONTAINER_NAME%]
        docker rm --force "%CONTAINER_NAME%")
    
    )

docker run ^
    -it ^
    -p 3000:3000 ^
    -e MESSAGE_STORE_USER='message_store' ^
    -e MESSAGE_STORE_HOST='messagestore' ^
    -e MESSAGE_STORE_DATABASE='message_store' ^
    -e MESSAGE_STORE_PASSWORD='' ^
    -e MESSAGE_STORE_PORT=5432 ^
    --name %CONTAINER_NAME% ^
    --link messagestore ^
    %IMAGE%:latest