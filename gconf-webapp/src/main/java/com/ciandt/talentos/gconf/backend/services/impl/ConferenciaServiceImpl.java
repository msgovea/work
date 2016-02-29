package com.ciandt.talentos.gconf.backend.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import com.ciandt.talentos.gconf.backend.dao.ConferenciaRepository;
import com.ciandt.talentos.gconf.backend.entities.Conferencia;
import com.ciandt.talentos.gconf.backend.services.ConferenciaService;

@Service
public class ConferenciaServiceImpl implements ConferenciaService {

	@Autowired
	private ConferenciaRepository conferenciaRepository;

	
	@Override
	public List<Conferencia> findConferenciasByTituloContainingIgnoreCase(String Titulo) {
		Assert.hasText(Titulo, "O titulo para pesquisa deve ser informado!");
		return conferenciaRepository.findByTituloContainingIgnoreCase(Titulo);
	}

}
