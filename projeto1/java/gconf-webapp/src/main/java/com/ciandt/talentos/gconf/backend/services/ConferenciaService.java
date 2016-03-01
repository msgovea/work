package com.ciandt.talentos.gconf.backend.services;

import java.util.List;


import com.ciandt.talentos.gconf.backend.entities.Conferencia;

public interface ConferenciaService {

	//List<Conferencia> findConferenciaByTituloOrOrganizadorOrAssuntoContainingIgnoreCase(String titulo, String organizador, String assunto);
	
	List<Conferencia> findBySearchTerm(String titulo, String organizador, String assunto );
}
