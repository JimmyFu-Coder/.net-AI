# build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY Api/ Api/
RUN dotnet publish Api/Api.csproj -c Release -o /app -f net9.0

# run：aspnet 9 + Lambda Web Adapter 
FROM mcr.microsoft.com/dotnet/aspnet:9.0

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app
COPY --from=build /app .
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENV PORT=8080
ENTRYPOINT ["dotnet", "Api.dll"]
