FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["AuthApi/AuthApi/AuthApi.csproj", "AuthApi/AuthApi/"]
COPY ["AuthApi/AuthApi.Application/AuthApi.Application.csproj", "AuthApi/AuthApi.Application/"]
COPY ["AuthApi/AuthApi.Domain/AuthApi.Domain.csproj", "AuthApi/AuthApi.Domain/"]
COPY ["AuthApi/AuthApi.Infrastructure/AuthApi.Infrastructure.csproj", "AuthApi/AuthApi.Infrastructure/"]
COPY ["/Shared/SharedApi/SharedApi.csproj", "Shared/SharedApi/"]
RUN dotnet restore "AuthApi/AuthApi/AuthApi.csproj"
COPY "AuthApi/" "AuthApi/"
COPY "Shared/SharedApi" "Shared/SharedApi"
WORKDIR "/src/AuthApi/AuthApi/"
RUN dotnet build "AuthApi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "AuthApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AuthApi.dll"]
