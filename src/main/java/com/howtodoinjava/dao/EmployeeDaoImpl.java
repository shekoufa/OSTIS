package com.howtodoinjava.dao;

import java.util.List;

import com.howtodoinjava.entity.Translation;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.howtodoinjava.entity.Employee;

@Repository(value = "employeDAO")
public class EmployeeDaoImpl implements EmployeeDAO  
{
	//Session factory injected by spring context
    @Autowired
    private SessionFactory sessionFactory;
	
    //This method will be called when a employee object is added
	@Override
	public void addEmployee(Employee employee) {
		this.sessionFactory.getCurrentSession().save(employee);
	}

	//This method return list of employees in database
	@SuppressWarnings("unchecked")
	@Override
	public List<Employee> getAllEmployees() {
		return this.sessionFactory.getCurrentSession().createQuery("from Employee").list();
	}

	//Deletes a employee by it's id
	@Override
	public void deleteEmployee(Integer employeeId) {
		Employee employee = (Employee) sessionFactory.getCurrentSession()
										.load(Employee.class, employeeId);
        if (null != employee) {
        	this.sessionFactory.getCurrentSession().delete(employee);
        }
	}

    @Override
    public List<Translation> findTranslationByWordEn(String enWord) {
        enWord = enWord.toLowerCase();
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("enWord",enWord)).add(Restrictions.eq("status","approved")).list();
    }

    @Override
    public List<Translation> findTranslationByWordFa(String faWord) {
        faWord = faWord.toLowerCase();
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("faWord", faWord)).add(Restrictions.eq("status", "approved")).list();
    }

    @Override
    public List<Translation> findPendingTranslationsByWordFa() {
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("status","pending")).add(Restrictions.isNotNull("faWord")).list();
    }
    @Override
    public List<Translation> findPendingTranslationsByWordEn() {
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("status","pending")).add(Restrictions.isNotNull("enWord")).list();
    }

    @Override
    public List<Translation> findTranslationByWordEnStatusless(String enWord) {
        enWord = enWord.toLowerCase();
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("enWord", enWord)).list();
    }

    @Override
    public List<Translation> findTranslationByWordFaStatusless(String faWord) {
        faWord = faWord.toLowerCase();
        return this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("faWord", faWord)).list();
    }



    @Override
    public void addRequest(String reqWord) {
        reqWord = reqWord.toLowerCase();
        Translation translation = new Translation();
        translation.setFaWord(reqWord);
        translation.setStatus("pending");
        this.sessionFactory.getCurrentSession().save(translation);
    }

    @Override
    public Translation findTranslationById(Integer wordId) {
        return (Translation) this.sessionFactory.getCurrentSession().createCriteria(Translation.class)
                .add(Restrictions.eq("id", wordId)).uniqueResult();
    }

    @Override
    public void remove(Object theObject) {
        this.sessionFactory.getCurrentSession().delete(theObject);
    }

    @Override
    public void updateTranslation(Translation translation) {
        this.sessionFactory.getCurrentSession().update(translation);
    }

    //This setter will be used by Spring context to inject the sessionFactory instance
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
}
