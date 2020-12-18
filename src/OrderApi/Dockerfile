FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["OrderApi/OrderApi.csproj", "OrderApi/OrderApi/"]
COPY ["OrderApi.Application/OrderApi.Application.csproj", "OrderApi/OrderApi.Application/"]
COPY ["OrderApi.Domain/OrderApi.Domain.csproj", "OrderApi/OrderApi.Domain/"]
COPY ["OrderApi.Infrastructure/OrderApi.Infrastructure.csproj", "OrderApi/OrderApi.Infrastructure/"]
RUN dotnet restore "OrderApi/OrderApi/OrderApi.csproj"
COPY . "OrderApi/"
WORKDIR "/src/OrderApi/OrderApi/"
RUN dotnet build "OrderApi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "OrderApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OrderApi.dll"]
