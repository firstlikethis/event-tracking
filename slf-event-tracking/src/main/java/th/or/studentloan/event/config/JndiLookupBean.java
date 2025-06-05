package th.or.studentloan.event.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import org.springframework.beans.factory.FactoryBean;

public class JndiLookupBean implements FactoryBean<DataSource> {
    
    @Override
    public DataSource getObject() throws Exception {
        Context ctx1 = new InitialContext();
        Context envContext = (Context) ctx1.lookup("java:/comp/env"); 
        return (DataSource) envContext.lookup("jdbc/SLFORA19");
    }
    
    @Override
    public Class<DataSource> getObjectType() {
        return DataSource.class;
    }
    
    @Override
    public boolean isSingleton() {
        return true;
    }
}