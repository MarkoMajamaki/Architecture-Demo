FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["CustomerApi/CustomerApi/CustomerApi.csproj", "CustomerApi/CustomerApi/"]
COPY ["CustomerApi/CustomerApi.Application/CustomerApi.Application.csproj", "CustomerApi/CustomerApi.Application/"]
COPY ["CustomerApi/CustomerApi.Domain/CustomerApi.Domain.csproj", "CustomerApi/CustomerApi.Domain/"]
COPY ["CustomerApi/CustomerApi.Infrastructure/CustomerApi.Infrastructure.csproj", "CustomerApi/CustomerApi.Infrastructure/"]
COPY ["/Shared/SharedApi/SharedApi.csproj", "Shared/SharedApi/"]
RUN dotnet restore "CustomerApi/CustomerApi/CustomerApi.csproj"
COPY "CustomerApi/" "CustomerApi/"
COPY "Shared/SharedApi" "Shared/SharedApi"
WORKDIR "/src/CustomerApi/CustomerApi/"
RUN dotnet build "CustomerApi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "CustomerApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CustomerApi.dll"]
