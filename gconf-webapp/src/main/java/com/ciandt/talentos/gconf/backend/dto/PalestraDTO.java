package com.ciandt.talentos.gconf.backend.dto;

import com.ciandt.talentos.gconf.backend.entities.Palestra;
import com.ciandt.talentos.gconf.backend.entities.Palestra.TipoPalestra;

public class PalestraDTO {

	private Long id;
	private String titulo;
	private String resumo;
	private TipoPalestra tipoPatestra;

	
	public PalestraDTO() {}

	public PalestraDTO(Palestra entity){
		this.id = entity.getId();
		this.titulo = entity.getTitulo();
		this.resumo = entity.getResumo();
		this.tipoPatestra = entity.getTipoPatestra();
	}
	
	public Palestra toEntity() {
		return new Palestra(getId(), getTitulo(), getResumo(), getTipoPatestra());
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getResumo() {
		return resumo;
	}

	public void setResumo(String resumo) {
		this.resumo = resumo;
	}

	public TipoPalestra getTipoPatestra() {
		return tipoPatestra;
	}

	public void setTipoPatestra(TipoPalestra tipoPatestra) {
		this.tipoPatestra = tipoPatestra;
	}

}
