package com.ciandt.talentos.gconf.backend.services;

import java.util.List;

import com.ciandt.talentos.gconf.backend.entities.Conferencia;

public interface ConferenciaService {
	
	List<Conferencia> findConferenciasByTituloContainingIgnoreCase(String Titulo);
}
