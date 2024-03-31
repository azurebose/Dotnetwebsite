FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["mywebsite/mywebsite.csproj", "mywebsite/"]
RUN dotnet restore "mywebsite/mywebsite.csproj"
COPY . .
WORKDIR "/src/mywebsite"
RUN dotnet build "mywebsite.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "mywebsite.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mywebsite.dll"]
