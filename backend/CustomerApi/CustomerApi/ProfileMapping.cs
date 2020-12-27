using AutoMapper;
using CustomerApi.Domain;

namespace CustomerApi
{
    public class ProfileMapping : Profile
    {
        public ProfileMapping()
        {
            CreateMap<CreateCustomerModel, Customer>().ForMember(x => x.Id, opt => opt.Ignore());
            CreateMap<UpdateCustomerModel, Customer>();
        }
    }
}