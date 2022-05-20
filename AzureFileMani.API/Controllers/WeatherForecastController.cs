using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Collections.Generic;
namespace AzureFileMani.API.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;

    public WeatherForecastController(ILogger<WeatherForecastController> logger)
    {
        _logger = logger;
    }

    //[HttpGet(Name = "GetWeatherForecast")]
    //public IEnumerable<WeatherForecast> Get()
    //{
    //    return Enumerable.Range(1, 5).Select(index => new WeatherForecast
    //    {
    //        Date = DateTime.Now.AddDays(index),
    //        TemperatureC = Random.Shared.Next(-20, 55),
    //        Summary = Summaries[Random.Shared.Next(Summaries.Length)]
    //    })
    //    .ToArray();
    //}

    [HttpGet]
    public List<FileInfo> TestApi()
    {
        List<FileInfo> path = new List<FileInfo>();
        string[] files = Directory.GetFiles(@"./fileBuffer", "*");
        foreach (var file in files)
        {
            var fileInfo = new FileInfo();
            fileInfo.Path = file;
            path.Add(fileInfo);
            //path.Add(file);
        }

        string[] subdirectoryEntries = Directory.GetDirectories(@"./fileBuffer");

        foreach (string subdirectory in subdirectoryEntries)
        {
            var fileInfo = new FileInfo();
            fileInfo.Path = subdirectory;
            path.Add(fileInfo);
        }
        return path;
    }

    public class FileInfo
    {
        public string Path { get; set; }
    }

}
