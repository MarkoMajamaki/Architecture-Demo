FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ServiceA.Api/ServiceA.Api.csproj", "ServiceA/ServiceA.Api/"]
COPY ["ServiceA.Application/ServiceA.Application.csproj", "ServiceA/ServiceA.Application/"]
COPY ["ServiceA.Domain/ServiceA.Domain.csproj", "ServiceA/ServiceA.Domain/"]
COPY ["ServiceA.Infrastructure/ServiceA.Infrastructure.csproj", "ServiceA/ServiceA.Infrastructure/"]
RUN dotnet restore "ServiceA/ServiceA.Api/ServiceA.Api.csproj"
COPY . "ServiceA/"
WORKDIR "/src/ServiceA/ServiceA.Api/"
RUN dotnet build "ServiceA.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "ServiceA.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ServiceA.Api.dll"]
