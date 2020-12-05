FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/ServiceA/ServiceA.Api/ServiceA.Api.csproj", "src/ServiceA/ServiceA.Api/"]
COPY ["src/ServiceA/ServiceA.Application/ServiceA.Application.csproj", "src/ServiceA/ServiceA.Application/"]
COPY ["src/ServiceA/ServiceA.Domain/ServiceA.Domain.csproj", "src/ServiceA/ServiceA.Domain/"]
COPY ["src/ServiceA/ServiceA.Infrastructure/ServiceA.Infrastructure.csproj", "src/ServiceA/ServiceA.Infrastructure/"]
RUN dotnet restore "src/ServiceA/ServiceA.Api/ServiceA.Api.csproj"
COPY . .
WORKDIR "/src/src/ServiceA/ServiceA.Api"
RUN dotnet build "ServiceA.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ServiceA.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ServiceA.Api.dll"]
