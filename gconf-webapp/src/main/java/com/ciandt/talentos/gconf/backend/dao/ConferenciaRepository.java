package com.ciandt.talentos.gconf.backend.dao;

import java.util.List;

import org.springframework.data.repository.Repository;

import com.ciandt.talentos.gconf.backend.entities.Conferencia;

public interface ConferenciaRepository extends Repository<Conferencia, Long> {

	Conferencia getById(Long conferenciaId);
		
	List<Conferencia> findByTituloContainingIgnoreCase(String Titulo);
}

