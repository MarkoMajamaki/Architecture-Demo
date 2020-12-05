FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/ServiceB/ServiceB.Api/ServiceB.Api.csproj", "src/ServiceB/ServiceB.Api/"]
COPY ["src/ServiceB/ServiceB.Application/ServiceB.Application.csproj", "src/ServiceB/ServiceB.Application/"]
COPY ["src/ServiceB/ServiceB.Domain/ServiceB.Domain.csproj", "src/ServiceB/ServiceB.Domain/"]
COPY ["src/ServiceB/ServiceB.Infrastructure/ServiceB.Infrastructure.csproj", "src/ServiceB/ServiceB.Infrastructure/"]
RUN dotnet restore "src/ServiceB/ServiceB.Api/ServiceB.Api.csproj"
COPY . .
WORKDIR "/src/src/ServiceB/ServiceB.Api"
RUN dotnet build "ServiceB.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ServiceB.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ServiceB.Api.dll"]
