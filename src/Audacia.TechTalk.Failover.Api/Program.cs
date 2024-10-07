using Microsoft.AspNetCore.Authorization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen().AddHealthChecks();
;

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet(
        "/hosted-region",
        () =>
        {
            var hostedRegion = Environment.GetEnvironmentVariable("REGION_NAME") ?? "";
            return hostedRegion;
        })
    .WithName("GetHostedRegion")
    .WithOpenApi();

app.MapHealthChecks("/health").WithMetadata(new AllowAnonymousAttribute());

app.Run();