package com.ciandt.talentos.gconf.backend.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import com.ciandt.talentos.gconf.backend.entities.Conferencia;

public interface ConferenciaRepository extends Repository<Conferencia, Long> {

	Conferencia getById(Long conferenciaId);
	
	//List<Conferencia> findConferenciaByTituloOrOrganizadorOrAssuntoContainingIgnoreCase(String titulo, String organizador, String assunto);
	
	
	 @Query("SELECT c FROM Conferencia c WHERE " +
	            "(:titulo is null or LOWER(c.titulo) LIKE LOWER(CONCAT('%',:titulo, '%'))) AND " +
	            "(:organizador is null or LOWER(c.organizador) LIKE LOWER(CONCAT('%',:organizador, '%'))) AND " +
	            "(:assunto is null or LOWER(c.assunto) LIKE LOWER(CONCAT('%',:assunto, '%')))" )
	 List<Conferencia> findBySearchTerm(@Param("titulo") String titulo, @Param("organizador") String organizador, @Param("assunto") String assunto );
	  
}
