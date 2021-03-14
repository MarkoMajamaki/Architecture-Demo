namespace AuthApi.Application
{
    public interface IFacebookAuthSettings 
    {
        string AppId { get; }
        string AppSecret { get; }
    }

    public class FacebookAuthSettings : IFacebookAuthSettings
    {
        public string AppId { get; private set; }
        public string AppSecret { get; private set; }

        public FacebookAuthSettings(string appId, string appSecret)
        {
            AppId = appId;
            AppSecret = appSecret;
        }
    }
}