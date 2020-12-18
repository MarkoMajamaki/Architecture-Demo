using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CustomerApi.Domain
{
    public interface IRepository<TEntity> where TEntity : class, new()
    {
        IEnumerable<TEntity> GetAll();
        TEntity GetSingle(Guid id);
        Task<TEntity> AddAsync(TEntity entity);
        Task<TEntity> DeleteAsync(TEntity entity);
        Task<TEntity> UpdateAsync(TEntity entity);

    }
}