package com.ciandt.talentos.gconf.backend.dao;


import java.util.List;

import org.springframework.data.repository.Repository;

import com.ciandt.talentos.gconf.backend.entities.Palestra;

public interface PalestraRepository extends Repository<Palestra, Long> {

	Palestra getById(Long palestraId);
		
	List<Palestra> findByTitulo(String Titulo);
}
