package com.ciandt.talentos.gconf.backend.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import com.ciandt.talentos.gconf.backend.dao.PalestraRepository;
import com.ciandt.talentos.gconf.backend.entities.Palestra;
import com.ciandt.talentos.gconf.backend.services.PalestraService;

@Service
public class PalestraServiceImpl implements PalestraService {
	
	@Autowired
	private PalestraRepository palestraRepository;
	
	@Override
	public List<Palestra> findPalestrasByTitulo(String Titulo) {
		Assert.hasText(Titulo, "O titulo para pesquisa deve ser informado!");
		return palestraRepository.findByTitulo(Titulo);
	}

}
