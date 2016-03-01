package com.ciandt.talentos.gconf.backend.dao;


import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import com.ciandt.talentos.gconf.backend.entities.Palestra;

public interface PalestraRepository extends Repository<Palestra, Long> {

	Palestra getById(Long palestraId);
	
	@Query("select p from Palestra p "
			+ "where (:titulo is null or upper(p.titulo) like upper(concat('%',:titulo,'%'))) "
			+ "and (:palestranteId=0L or p.palestrante.id= :palestranteId)")
	List<Palestra> findByTituloAndPalestranteIdNoRequered(
			@Param("titulo") String titulo, 
			@Param("palestranteId") Long palestranteId);
}
