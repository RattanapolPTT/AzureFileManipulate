

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app
EXPOSE 80 2222

ENV ASPNETCORE_URLS=http://+:5555


# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh \
     && echo "root:Docker!" | chpasswd 

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)



# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /src
COPY ["AzureFileMani.API/AzureFileMani.API.csproj", "AzureFileMani.API/"]
RUN dotnet restore "AzureFileMani.API/AzureFileMani.API.csproj"
COPY . .
WORKDIR "/src/AzureFileMani.API"
RUN dotnet build "AzureFileMani.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AzureFileMani.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "AzureFileMani.API.dll"]
ENTRYPOINT ["/usr/sbin/sshd"]
#  ENTRYPOINT ["/usr/bin/supervisord && dotnet AzureFileMani.API.dll"]
