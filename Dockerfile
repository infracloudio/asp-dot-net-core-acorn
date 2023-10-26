FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY BlazingPizza.sln ./
COPY . .

RUN dotnet restore "/src/BlazingPizza.Server/BlazingPizza.Server.csproj"

#RUN dotnet restore

COPY . .
RUN dotnet build "/src/BlazingPizza.Server/BlazingPizza.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "/src/BlazingPizza.Server/BlazingPizza.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazingPizza.Server.dll"]
