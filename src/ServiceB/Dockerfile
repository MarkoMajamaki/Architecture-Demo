FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ServiceB.Api/ServiceB.Api.csproj", "ServiceB/ServiceB.Api/"]
COPY ["ServiceB.Application/ServiceB.Application.csproj", "ServiceB/ServiceB.Application/"]
COPY ["ServiceB.Domain/ServiceB.Domain.csproj", "ServiceB/ServiceB.Domain/"]
COPY ["ServiceB.Infrastructure/ServiceB.Infrastructure.csproj", "ServiceB/ServiceB.Infrastructure/"]
RUN dotnet restore "ServiceB/ServiceB.Api/ServiceB.Api.csproj"
COPY . "ServiceB/"
WORKDIR "/src/ServiceB/ServiceB.Api/"
RUN dotnet build "ServiceB.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "ServiceB.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ServiceB.Api.dll"]
