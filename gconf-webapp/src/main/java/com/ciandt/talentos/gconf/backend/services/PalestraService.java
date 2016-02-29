package com.ciandt.talentos.gconf.backend.services;

import java.util.List;

import com.ciandt.talentos.gconf.backend.entities.Palestra;

public interface PalestraService {

	List<Palestra> findPalestrasByTitulo(String Titulo);

}