```docker
    ## Previous ##                                    ## Optimized ##

FROM debian                                     FROM openjdk:11-jre-slim
COPY . /app                                     COPY target/app.jar app.jar
RUN apt-get update                              ENTRYPOINT ["java", "-jar", "/app.jar"]
RUN apt-get -y install default-jdk ssh vim
CMD ["java", "-jar", "/app/target/app.jar"]
```

```docker
~ FROM (debian  ->  openjdk:11-jdk-alpine)
```

파일 실행을 위해 jdk 를 직접 설치하는것은 빠른 실행이 필요한 컨테이너에 태클을 거는 격이라고 생각합니다. <br>
debian 경량 이미지 위에 jdk 를 별도로 설치하지 않고, 빠른 컨테이너 실행을 위해 최적화된 openjdk 공식 경량 이미지인 11-jdk-alpine 을 사용해보았습니다. <br>
Java 애플리케이션 개발과 배포 경험이 많지 않아 이미지 경량화 및 최적화에 중점을 두었습니다. <br>

```docker
- RUN apt-get update && apt-get install ssh vim -y
```

애플리케이션 실행을 위한 컨테이너에 ssh 와 vim 프로그램은 불필요하다고 판단하여 삭제했습니다. <br>
 ~~불필요한 이미지 스택을 간소화하기 위해 RUN Command 를 통합해보았습니다.~~ <br>

```docker
~ (CMD -> ENTRYPOINT) ["java", "-jar", "/app.jar"]
```

CMD 보다 ENTRYPOINT Command 가 확장성이 좋으며과 경험상의 오류가 적었습니다 <br>
