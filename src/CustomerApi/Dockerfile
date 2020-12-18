FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["CustomerApi/CustomerApi.csproj", "CustomerApi/CustomerApi/"]
COPY ["CustomerApi.Application/CustomerApi.Application.csproj", "CustomerApi/CustomerApi.Application/"]
COPY ["CustomerApi.Domain/CustomerApi.Domain.csproj", "CustomerApi/CustomerApi.Domain/"]
COPY ["CustomerApi.Infrastructure/CustomerApi.Infrastructure.csproj", "CustomerApi/CustomerApi.Infrastructure/"]
RUN dotnet restore "CustomerApi/CustomerApi/CustomerApi.csproj"
COPY . "CustomerApi/"
WORKDIR "/src/CustomerApi/CustomerApi/"
RUN dotnet build "CustomerApi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "CustomerApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CustomerApi.dll"]
