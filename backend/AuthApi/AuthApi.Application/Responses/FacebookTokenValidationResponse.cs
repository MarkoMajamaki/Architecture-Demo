using System.Globalization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace AuthApi.Application
{
    public partial class FacebookTokenValidationResponse
    {
        [JsonProperty("data")]
        public Data Data { get; set; }
    }

    public partial class Data
    {
        [JsonProperty("app_id")]
        public string AppId { get; set; }

        [JsonProperty("type")]
        public string Type { get; set; }

        [JsonProperty("application")]
        public string Application { get; set; }

        [JsonProperty("data_access_expires_at")]
        public long DataAccessExpiresAt { get; set; }

        [JsonProperty("expires_at")]
        public long ExpiresAt { get; set; }

        [JsonProperty("is_valid")]
        public bool IsValid { get; set; }

        [JsonProperty("issued_at")]
        public long IssuedAt { get; set; }

        [JsonProperty("metadata")]
        public Metadata Metadata { get; set; }

        [JsonProperty("scopes")]
        public string[] Scopes { get; set; }

        [JsonProperty("user_id")]
        public string UserId { get; set; }
    }

    public partial class Metadata
    {
        [JsonProperty("auth_type")]
        public string AuthType { get; set; }

        [JsonProperty("sso")]
        public string Sso { get; set; }
    }

    public partial class FacebookTokenValidationResponse
    {
        public static FacebookTokenValidationResponse FromJson(string json) => JsonConvert.DeserializeObject<FacebookTokenValidationResponse>(json, AuthApi.Application.Converter.Settings);
    }

    public static class Serialize
    {
        public static string ToJson(this FacebookTokenValidationResponse self) => JsonConvert.SerializeObject(self, AuthApi.Application.Converter.Settings);
    }

    internal static class Converter
    {
        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            Converters =
            {
                new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.AssumeUniversal }
            },
        };
    }
}